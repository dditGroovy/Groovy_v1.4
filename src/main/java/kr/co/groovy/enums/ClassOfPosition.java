package kr.co.groovy.enums;

public enum ClassOfPosition {
    CLSF010("이사"), CLSF011("부장"), CLSF012("팀장"), CLSF013("차장"), CLSF014("과장"), CLSF015("대리"), CLSF016("사원");

    private final String label;

    ClassOfPosition(String label) {
        this.label = label;
    }

    public String label() {
        return label;
    }
}
